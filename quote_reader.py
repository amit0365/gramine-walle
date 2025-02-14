def read_quote(quote_path="/dev/attestation/quote"):
    try:
        with open(quote_path, "rb") as f:
            quote = f.read()
            return quote
    except Exception as e:
        print(f"Error reading {quote_path}: {e}")
        return None

if __name__ == "__main__":
    quote = read_quote()
    if quote is not None:
        print("Attestation quote read successfully:")
        print("Quote (hex):", quote.hex())
    else:
        print("Failed to read attestation quote.")