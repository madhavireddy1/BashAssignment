import subprocess
import platform
import re
import sys

def ping_host(host):
    os_name = platform.system().lower()
    if os_name == "windows":
        cmd = ["ping", "-n", "4", host]
    else:
        cmd = ["ping", "-c", "4", host]
    
    try:
        result = subprocess.run(cmd, capture_output=True, text=True, timeout=10)
        output = result.stdout
        if result.returncode == 0:
            if os_name == "windows":
                match = re.search(r"Average = (\d+)ms", output)
            else:
                match = re.search(r"min/avg/max.*?= [\d.]+/([\d.]+)/", output)
            avg_time = match.group(1) if match else "N/A"
            return True, avg_time
        else:
            return False, None
    except subprocess.TimeoutExpired:
        return False, None
    except Exception as e:
        print(f"Error pinging {host}: {e}")
        return False, None

def scan_multiple_hosts(hosts):
    print(f"\n{'Host':<20} {'Status':<10} {'Avg Response'}")
    print("-" * 45)
    for host in hosts:
        alive, response_time = ping_host(host)
        status = "UP ✓" if alive else "DOWN ✗"
        rt = f"{response_time}ms" if response_time else "N/A"
        print(f"{host:<20} {status:<10} {rt}")

def main():
    print("=== Ping Scanner ===")
    print("1. Scan single host")
    print("2. Scan multiple hosts")
    choice = input("Choose (1/2): ").strip()
    
    if choice == "1":
        host = input("Enter hostname or IP: ").strip()
        alive, rt = ping_host(host)
        if alive:
            print(f"\n{host} is UP | Avg response: {rt}ms")
        else:
            print(f"\n{host} is DOWN or unreachable")
    
    elif choice == "2":
        raw = input("Enter hosts separated by commas: ").strip()
        hosts = [h.strip() for h in raw.split(",")]
        scan_multiple_hosts(hosts)
    
    else:
        print("Invalid choice")

if __name__ == "__main__":
    main()
