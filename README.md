# tasks_and_solutions
The folder includes a lot of snippets written down while I was working in the Belarussian Institute of Genetics and Cytology, 2018-2020. They could be considered as a brief explanation of my work there by itself </br>
I had been writing them for 2 years - they can significantly differ from each other by level of language and type of chosen solution.</br></br>

But, of course, I didn't spend time adding features like input params/files/paths from the command line, handling of exceptions, and standard output messages about a working state. You need to open every script by your favorite IDE (but I usually use vim),  read the body and comments, change paths_to, check programs.</br>

Most of the scripts are using for working with vcf-files or their obtaining. They can be helpful to take a look at the programs and workflow. </br>

p.s. And almost all have relative paths to programs through home_dir. Cause I didn't love to "make install" / to add every new prog to PATH. But then I thought up the weird way - I make special my_dir with links to progs and add the my_dir to the PATH. (I think it's the way how to "make install" work - by adding links to /usr/local/bin that in PATH)
