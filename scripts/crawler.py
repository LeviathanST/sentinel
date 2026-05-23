import os
import requests
from bs4 import BeautifulSoup
from urllib.parse import urljoin

# The Source of Truth: Karpathy's digital footprint
BASE_URL = "https://karpathy.ai/"
CORPUS_DIR = "CORPUS"

def ingest_blog():
    """
    Scrapes the primary blog index and downloads all linked .html posts.
    Strips HTML noise to preserve the 'Algorithmic Essence' of the thoughts.
    """
    if not os.path.exists(CORPUS_DIR):
        os.makedirs(CORPUS_DIR)

    print(f"--- Loading RAM from {BASE_URL} ---")
    
    try:
        response = requests.get(BASE_URL, timeout=10)
        response.raise_for_status()
    except Exception as e:
        print(f"ERROR: Could not access {BASE_URL}: {e}")
        return

    soup = BeautifulSoup(response.text, 'html.parser')

    # Find all internal links to .html files (blog posts)
    links = soup.find_all('a', href=True)
    blog_links = [urljoin(BASE_URL, l['href']) for l in links if l['href'].endswith('.html')]

    # Remove duplicates
    blog_links = list(set(blog_links))

    print(f"Found {len(blog_links)} potential signal sources. Starting ingestion...")

    for link in blog_links:
        file_name = link.split('/')[-1].replace('.html', '.md')
        file_path = os.path.join(CORPUS_DIR, file_name)

        try:
            post_res = requests.get(link, timeout=10)
            post_res.raise_for_status()
            post_soup = BeautifulSoup(post_res.text, 'html.parser')
            
            # Extract the text (stripping away the HTML noise)
            text = post_soup.get_text(separator='\n')
            
            with open(file_path, 'w', encoding='utf-8') as f:
                f.write(f"--- SOURCE: {link} ---\n\n")
                f.write(text.strip())
            
            print(f"SUCCESS: Ingested {file_name}")
        except Exception as e:
            print(f"FAILED: Could not ingest {link}: {e}")

    print(f"\n--- Ingestion Complete. Check the {CORPUS_DIR}/ folder. ---")

if __name__ == "__main__":
    ingest_blog()
