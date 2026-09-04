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

	| repository importer downloadedFolder expectedFolder |
	repository := MiGithubRepositoryStub owner: 'moosetechnology' projectName: 'MooseIDE'.
	importer := MiGithubImporter new
		            repository: repository;
		            versions: OrderedCollection new;
		            yourself.
	downloadedFolder := importer folderForVersion: (MiGithubVersion tagNamed: 'v1.0').
	expectedFolder := FileLocator imageDirectory / 'github-moose-cache' / 'MooseIDE' / 'v1.0'.

	self assert: downloadedFolder fullName equals: expectedFolder fullName
]

{ #category : 'tests' }
MiGithubImporterTest >> testIsLanguageSupported [

	self assert: (MiGithubImporter isLanguageSupported: 'Java').
	self deny: (MiGithubImporter isLanguageSupported: 'Python').
	self deny: (MiGithubImporter isLanguageSupported: nil)
]
