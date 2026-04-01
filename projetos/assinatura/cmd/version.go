package cmd

import (
	"fmt"
	"runtime"

	"github.com/spf13/cobra"
)

var version = "0.0.2"

var versionCmd = &cobra.Command{
	Use:   "version",
	Short: "Exibe a versão atual do CLI",
	Long:  `Exibe a versão atual do CLI assinatura e outras informações de sistema.`,
	Run: func(cmd *cobra.Command, args []string) {
		fmt.Printf("Assinatura CLI v%s %s/%s\n", version, runtime.GOOS, runtime.GOARCH)
	},
}

func init() {
	rootCmd.AddCommand(versionCmd)
}
