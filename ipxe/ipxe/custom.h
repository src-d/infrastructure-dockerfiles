// enables VLAN support
#define VLAN_CMD		/* VLAN commands */

// disable crypto - avoids +20 seconds boot delay
#undef	CRYPTO_80211_WEP	/* WEP encryption (deprecated and insecure!) */
#undef	CRYPTO_80211_WPA	/* WPA Personal, authenticating with passphrase */
#undef	CRYPTO_80211_WPA2	/* Add support for stronger WPA cryptography */