"
I test MiGithubImporter: the language support policy and the layout of the cache directory. I never access the network.
"
Class {
	#name : 'MiGithubImporterTest',
	#superclass : 'TestCase',
	#category : 'MooseIDE-Github-Importer-Tests-Tests',
	#package : 'MooseIDE-Github-Importer-Tests',
	#tag : 'Tests'
}

{ #category : 'tests' }
MiGithubImporterTest >> testFolderForVersion [

	| importer downloadedFolder expectedFolder |
	importer := MiGithubImporter new
		            repository: (MiGithubRepository owner: 'moosetechnology' projectName: 'MooseIDE');
		            yourself.
	downloadedFolder := importer folderForVersion: (MiGithubVersion tagNamed: 'v1.0').
	expectedFolder := FileLocator localDirectory / 'github-moose-cache' / 'MooseIDE' / 'v1.0'.

	self assert: downloadedFolder equals: expectedFolder
]
