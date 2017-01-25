# RouterOS Management Scripts

This respository consists of various scripts designed to make certain aspects
of RouterOS more manageable. Some of them are simple scripts designed to do one
specific task, while others are complex scripts designed to add limited, 
additional, features in RouterOS.

## Disclaimer

The more complex scripts in this repository were designed on a low-load network 
where resources are plentiful. Many of them are separated into several 
functions to allow for re-use. While this might appropriate in more substantial 
programming languages and environments, such as C++ on multi-core processors, 
it is likely an unnecessary burdeon on the low-powered processors in Mikrotik 
hardware. These were written with a full understanding that they might not be 
as resource friendly as possible. Keep that in mind if you choose to use them.

## Installation and Use

Almost all of these scripts will require customization for your specific 
network. I've included snippets at the top and bottom of each file to speed up 
the testing process. 

The snippet at the top finds and removes any script by 
the same name, and associated global function. If you copy-paste the entire 
file, the snippet at the bottom runs the script after it is added, creating 
the global variable.

If you don't modify the core script, or if you're using these with any kind of 
automation, only the main script is required. Including the top and bottom 
snippets in a scheduler task, for example, will result in the deletion and 
recreation of the script everytime, which uses CPU time unnecessarily.

To install these scripts, copy-paste the entire file into a terminal session on 
your RouterOS device. Once the script has run, an identically named function 
will be created and available for use.

For example:
```
$fwList view dropLists
```

## Contributing

See [CONTRIBUTING](CONTRIBUTING.md)


## License

See [LICENSE](LICENSE)