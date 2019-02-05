# Build custom iPXE rom

This build a a custom iPXE rom with a [script](ipxe/script.ipxe), that connects to a given VLAN and `chain` to matchbox ipxe endpoint.
This build will output a `ipxe.lkrn` file for use in GRUB boot.

### Building the image

```sh
make build 
make BUILD NAME=ipxe-1234.lkrn VLAN=1234
```
