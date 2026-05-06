import subprocess

# Intentional vulnerability for SAST to find
def get_user(username):
    # BAD: SQL injection vulnerability
    query = "SELECT * FROM users WHERE name = '" + username + "'"
    return query

# BAD: Hardcoded secret (for demo - secret scanning should catch this)
# API_KEY = "super-secret-key-12345"

def main():
    print("Hello SecDevOps Demo")
    print(get_user("admin"))

if __name__ == "__main__":
    main()
