# backend/sitemap_parser.py
from bs4 import BeautifulSoup
import requests
from urllib.parse import urlparse, urlunparse

HEADERS = {"User-Agent": "Mozilla/5.0"}

def normalize_url(url: str) -> str:
    url = url.lower().strip() # Remove leading/trailing whitespace and convert to lowercase
    if not url.startswith("http"):
        url = "https://" + url
    
    if url.startswith("https://") and not url.startswith("https://www."):
        url = url.replace("https://", "https://www.", 1)
    elif not url.startswith("https://www."):
        url = "https://www." + url
    
    parsed = urlparse(url)

    # Normalize to scheme + netloc only (strip path, params, query, fragment)
    normalized_url = urlunparse((parsed.scheme, parsed.netloc, '', '', '', ''))
    return normalized_url

def fetch_sitemap(url): # Fetch each xml sitemap in one layer.
    try:
        response = requests.get(url, headers=HEADERS, timeout=5)
        response.raise_for_status()
        soup = BeautifulSoup(response.content, 'lxml-xml')
        return [loc.text for loc in soup.find_all('loc')]
    except Exception as e:
        print(f"Error: {e}")
        return []
def parse_sitemap(url): # Parse the sitemap and return a dictionary of URLs. Applies fetch_sitemap to each xml sitemap layer by layer.
    locs = fetch_sitemap(url)
    if not locs:
        return {url: []}
    
    tree = {}
    urls = []

    for loc in locs:
        if loc.endswith('.xml'):
            tree[loc] = parse_sitemap(loc)
        else:
            urls.append(loc)

    if tree and urls:
        tree["_final_urls"] = urls
        return tree
    elif urls:
        return urls
    else:
        return {url: tree}

def extract_final_urls(url): # List all URLs in the sitemap.
    
    url = normalize_url(url)
    final_urls = [url]
    if not url.endswith('/sitemap.xml'):
        url += '/sitemap.xml'
    tree = parse_sitemap(url)
    

    def _walk_tree(node):
        if isinstance(node, dict):
            for key, value in node.items():
                if key == "_final_urls" and isinstance(value, list):
                    final_urls.extend(value)
                else:
                    _walk_tree(value)
        elif isinstance(node, list):
            final_urls.extend([v for v in node if not v.endswith('.xml')])

    _walk_tree(tree)

    
    return final_urls, tree
