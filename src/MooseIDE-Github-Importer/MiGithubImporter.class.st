"
I download the sources of versions of a Github project (see MiGithubRepository and MiGithubVersion) and import them in MooseIDE as Famix models.

The sources are kept on disk in the 'github-moose-cache' directory next to the image, with one folder per project and one folder per version, so that the user can read the code.

For each downloaded version, I parse its folder with VerveineJ through FamixJavaFoldersImporter and install the resulting model.

Note: for now I only support Java projects. The check is done before with MiGithubImporter class>>isLanguageSupported:.

Usage:
```st
MiGithubImporter downloadAndImport: { (MiGithubVersion tagNamed: 'v1.0') } from: aMiGithubRepository
```
"
Class {
	#name : 'MiGithubImporter',
	#superclass : 'Object',
	#instVars : [
		'repository',
		'versions',
		'downloadedFolders'
	],
	#category : 'MooseIDE-Github-Importer-Importer',
	#package : 'MooseIDE-Github-Importer',
	#tag : 'Importer'
}

{ #category : 'instance creation' }
MiGithubImporter class >> cacheDirectoryName [
	"I am the name of the directory, next to the image directory, in which the sources of the projects are downloaded."

	^ 'github-moose-cache'
]

{ #category : 'instance creation' }
MiGithubImporter class >> downloadAndImport: aCollectionOfVersions from: aMiGithubRepository [

	^ self new
		  repository: aMiGithubRepository;
		  versions: aCollectionOfVersions;
		  downloadAndImport
]

{ #category : 'testing' }
MiGithubImporter class >> isLanguageSupported: aLanguage [
	"For now I only support Java projects."

	^ aLanguage = 'Java'
]

{ #category : 'private' }
MiGithubImporter >> cacheDirectory [

	^ FileLocator imageDirectory / self class cacheDirectoryName
]

{ #category : 'actions' }
MiGithubImporter >> download [
	"I download the sources of each version to import, with a job to show the progression."

	downloadedFolders := OrderedCollection new.
	[ :job |
		versions doWithIndex: [ :aVersion :index |
				job
					title: 'Downloading ' , aVersion displayName;
					progress: index - 1 / versions size.
				downloadedFolders add: (self downloadVersion: aVersion) ].
		job progress: 1 ] asJob run
]

{ #category : 'private' }
MiGithubImporter >> downloadAndExtractTarballOf: aVersion in: aFolder [

	| archiveReference |
	archiveReference := self cacheDirectory / (aVersion folderName , '.tar.gz').
	archiveReference parent ensureCreateDirectory.
	(ZnClient new
		 url: (repository downloadUrlForVersion: aVersion);
		 downloadTo: archiveReference pathString) ifFalse: [ self error: 'Cannot download the sources of ' , aVersion displayName ].
	LibC runCommand: 'tar -xzvf "' , archiveReference pathString , '" -C "' , aFolder pathString , '" --strip-components=1'.
	archiveReference ensureDelete
]

{ #category : 'actions' }
MiGithubImporter >> downloadAndImport [
	"I download the sources of all the versions and then import and install a model for each downloaded folder."

	self download.
	^ self import
]

{ #category : 'private' }
MiGithubImporter >> downloadVersion: aVersion [
	"I download and extract the sources of aVersion in a dedicated folder of the cache directory. I answer the downloaded folder."

	| folder |
	folder := self folderForVersion: aVersion.
	folder ensureDeleteAll.
	folder parent ensureCreateDirectory.
	folder ensureCreateDirectory.
	self downloadAndExtractTarballOf: aVersion in: folder.
	^ folder
]

{ #category : 'accessing' }
MiGithubImporter >> downloadedFolders [

	^ downloadedFolders
]

{ #category : 'private' }
MiGithubImporter >> folderForVersion: aVersion [

	^ self cacheDirectory / repository projectName / aVersion folderName
]

{ #category : 'actions' }
MiGithubImporter >> import [
	"I parse with VerveineJ through FamixJavaFoldersImporter and install a model for each downloaded folder."

	^ FamixJavaFoldersImporter importAndInstallFolders: downloadedFolders
]

{ #category : 'accessing' }
MiGithubImporter >> repository [

	^ repository
]

{ #category : 'accessing' }
MiGithubImporter >> repository: anObject [

	repository := anObject
]

{ #category : 'accessing' }
MiGithubImporter >> versions [

	^ versions
]

{ #category : 'accessing' }
MiGithubImporter >> versions: anObject [

	versions := anObject
]
