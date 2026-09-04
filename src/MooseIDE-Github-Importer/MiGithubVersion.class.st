"
I represent a downloadable version of a Github project: a tag, the head of a branch, a release or the head of a pull request.

I know:
- my kind (#tag, #branch, #release or #pullRequest)
- a display name to show in the UI
- the ref used to download my sources from Github (see MiGithubRepository>>downloadUrlForVersion:)

I also provide the name of the folder in which my sources are downloaded, relative to the project folder (see MiGithubImporter).
"
Class {
	#name : 'MiGithubVersion',
	#superclass : 'Object',
	#instVars : [
		'kind',
		'displayName',
		'downloadRef'
	],
	#category : 'MooseIDE-Github-Importer-Model',
	#package : 'MooseIDE-Github-Importer',
	#tag : 'Model'
}

{ #category : 'instance creation' }
MiGithubVersion class >> branchNamed: aString [

	^ self kind: #branch displayName: aString downloadRef: 'refs/heads/' , aString
]

{ #category : 'instance creation' }
MiGithubVersion class >> kind: aKind displayName: aDisplayName downloadRef: aDownloadRef [

	^ self new
		  kind: aKind;
		  displayName: aDisplayName;
		  downloadRef: aDownloadRef;
		  yourself
]

{ #category : 'instance creation' }
MiGithubVersion class >> pullRequestNumber: aNumber title: aString [

	^ self
		  kind: #pullRequest
		  displayName: ('Pull request #{1}: {2}' format: {
					   aNumber.
					   aString })
		  downloadRef: ('refs/pull/{1}/head' format: { aNumber })
]

{ #category : 'instance creation' }
MiGithubVersion class >> releaseNamed: aString [

	^ self kind: #release displayName: aString downloadRef: 'refs/tags/' , aString
]

{ #category : 'instance creation' }
MiGithubVersion class >> tagNamed: aString [

	^ self kind: #tag displayName: aString downloadRef: 'refs/tags/' , aString
]

{ #category : 'accessing' }
MiGithubVersion >> displayName [

	^ displayName
]

{ #category : 'accessing' }
MiGithubVersion >> displayName: anObject [

	displayName := anObject
]

{ #category : 'accessing' }
MiGithubVersion >> downloadRef [

	^ downloadRef
]

{ #category : 'accessing' }
MiGithubVersion >> downloadRef: anObject [

	downloadRef := anObject
]

{ #category : 'accessing' }
MiGithubVersion >> folderName [
	"I am the name of the folder in which my sources are downloaded, relative to the project folder (see MiGithubImporter). For pull requests I use the number of the pull request and for tags, branches and releases I replace the potential '/' of the name to not create nested folders."

	kind = #pullRequest ifTrue: [ ^ 'PR-' , ((downloadRef allButFirst: 'refs/pull/' size) copyUpTo: $/) ].
	^ displayName copyReplaceAll: '/' with: '-'
]

{ #category : 'accessing' }
MiGithubVersion >> iconName [
	"I am the name of the icon to display next to my kind in the UI, as in the Software Heritage importer. Tags and releases share the same icon."

	kind = #branch ifTrue: [ ^ #branch ].
	kind = #pullRequest ifTrue: [ ^ #merge ].
	^ #glamorousBookmark
]

{ #category : 'accessing' }
MiGithubVersion >> kind [

	^ kind
]

{ #category : 'accessing' }
MiGithubVersion >> kind: anObject [

	kind := anObject
]

{ #category : 'printing' }
MiGithubVersion >> printOn: aStream [

	super printOn: aStream.
	aStream
		<< ' (';
		<< kind asString;
		<< ': ';
		<< displayName;
		<< ')'
]
