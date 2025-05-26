from backend.parser import extract_final_urls
from backend.scraper import scrape_url
from backend.rag_store import store_to_db

def refresh_database(website="https://northlightai.com"):
    urls = extract_final_urls(website)
    for url in urls:
        try:
            text = scrape_url(url)
            store_to_db(url, text)
        except Exception as e:
            print(f"Failed on {url}: {e}")

if __name__ == "__main__":
    refresh_database()
