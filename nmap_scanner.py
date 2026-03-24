import subprocess
import platform
import sys
import shutil

def check_nmap():
    if shutil.which("nmap") is None:
        print("ERROR: Nmap is not installed.")
        print("Install it from: https://nmap.org/download.html")
        sys.exit(1)
    print("✓ Nmap is installed")

def run_nmap(target, scan_type, custom_ports=None):
    if scan_type == "1":
        cmd = ["nmap", "-sn", target]
        print(f"\nRunning host discovery on {target}...")
    elif scan_type == "2":
        cmd = ["nmap", "-p", "1-1000", target]
        print(f"\nScanning ports 1-1000 on {target}...")
    elif scan_type == "3":
        cmd = ["nmap", "-p", custom_ports, target]
        print(f"\nScanning custom ports {custom_ports} on {target}...")
    elif scan_type == "4":
        cmd = ["nmap", "-sV", target]
        print(f"\nRunning service detection on {target}...")
    elif scan_type == "5":
        cmd = ["nmap", "-O", target]
        print(f"\nRunning OS detection on {target}...")
        print("Note: OS detection requires sudo/root privileges")
    else:
        print("Invalid scan type")
        return

    try:
        result = subprocess.run(cmd, capture_output=True, text=True, timeout=120)
        print("\n--- Nmap Results ---")
        print(result.stdout)
        if result.stderr:
            print("Warnings:", result.stderr)
        return result.stdout
    except subprocess.TimeoutExpired:
        print("Scan timed out.")
        return None
    except Exception as e:
        print(f"Error running Nmap: {e}")
        return None

def save_to_file(output, filename="nmap_results.txt"):
    with open(filename, "w") as f:
        f.write(output)
    print(f"Results saved to {filename}")

def main():
    check_nmap()
    print("\n=== Nmap Scanner ===")
    target = input("Enter target IP (e.g. 127.0.0.1): ").strip()

    print("\nScan Types:")
    print("1. Host Discovery (-sn)")
    print("2. Port Scan 1-1000")
    print("3. Custom Port Scan")
    print("4. Service Detection (-sV)")
    print("5. OS Detection (-O) (needs sudo)")

    scan_type = input("\nChoose scan type (1-5): ").strip()

    custom_ports = None
    if scan_type == "3":
        custom_ports = input("Enter ports (e.g. 22,80,443 or 1-500): ").strip()

    output = run_nmap(target, scan_type, custom_ports)

    if output:
        save = input("\nSave results to file? (y/n): ").strip().lower()
        if save == "y":
            save_to_file(output)

if __name__ == "__main__":
    main()
