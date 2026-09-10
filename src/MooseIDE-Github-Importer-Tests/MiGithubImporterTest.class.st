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

{ #category : 'tests' }
MiGithubImporterTest >> testModelNameFromFolder [

	| repository importer |
	repository := MiGithubRepositoryStub owner: 'INRIA' projectName: 'VerveineJ'.
	importer := MiGithubImporter new
		            repository: repository;
		            versions: OrderedCollection new;
		            yourself.

	self assert: (importer modelNameFromFolder: 'v5' asFileReference) equals: 'VerveineJ-v5'.
	self assert: (importer modelNameFromFolder: 'v1.0.0' asFileReference) equals: 'VerveineJ-v1.0.0'.
	self assert: (importer modelNameFromFolder: 'PR-42' asFileReference) equals: 'VerveineJ-PR-42'
]
