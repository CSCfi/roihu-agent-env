package main

import (
	"io"
	"net"
	"os"
)

/*
This program simply copies the stdin to the socket /tmp/slurm-mcp.sock and the other way round.
The Opencode / Goose agent thinks the MCP server is local and uses STDIO, but this allows us to
pipe the requests and responses outside the container.
*/
func main() {
	c, err := net.Dial("unix", "/tmp/slurm-mcp.sock")
	if err != nil {
		panic(err)

	}
	defer c.Close()

	go func() {
		io.Copy(c, os.Stdin)           // opencode -> server
		c.(*net.UnixConn).CloseWrite() // propagate stdin EOF as a socket half-close
	}()
	io.Copy(os.Stdout, c) // server -> opencode
}
