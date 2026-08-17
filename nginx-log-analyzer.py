import sys
import shlex

def open_document(path):
    with open(path, "r", encoding="utf-8") as log:
        analyze_log(content=log)

def addresses_requests(count):
    print("Top 5 IP addresses with the most requests:")

    for i in sorted(count, key=count.get, reverse=True)[:5]:
        print(f"{i: <14} - {count[i]:<4} requests")


def most_requests(count):
    print("\nTop 5 most requested paths:")
    
    for i in sorted(count, key=count.get, reverse=True)[:5]:
        print(f"{i: <23} - {count[i]:<4} requests")

def response_status_code(count):
    print("\nTop 5 response status codes:")

    for i in sorted(count, key=count.get, reverse=True)[:5]:
        print(f"{i: <3} - {count[i]:<4} requests")

def user_agents(count):
    print("\nTop 5 user agents:")
        
    for i in sorted(count, key=count.get, reverse=True)[:5]:
        if i == "-":
            print(f"(sem User-Agent) - {count[i]:<4} requests")
        else:
            print(f"{i} - {count[i]:<4} requests")

def analyze_log(content):
    ip_count = {}
    path_count = {}
    status_count = {}
    agent_count = {}

    for line in content:
        fields = shlex.split(line)

        if line.strip():
            ip_address = line.split(maxsplit=1)[0]
            ip_count[ip_address] = ip_count.get(ip_address, 0) + 1

        status_code = fields[6]        
        status_count[status_code] = status_count.get(status_code, 0) + 1
        user_agent = fields[9]
        agent_count[user_agent] = agent_count.get(user_agent, 0) + 1

        requests = fields[5].split()
        if len(requests) <2:
            continue
        path = requests[1]
        path_count[path] = path_count.get(path, 0) + 1

    addresses_requests(ip_count)
    most_requests(path_count)
    response_status_code(status_count)
    user_agents(agent_count)

def main():
    if len(sys.argv) > 1:
        path = sys.argv[1]

    open_document(path=path)


main()