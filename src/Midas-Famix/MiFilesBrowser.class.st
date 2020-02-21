"
Please comment me using the following template inspired by Class Responsibility Collaborator (CRC) design:

For the Class part:  State a one line summary. For example, ""I represent a paragraph of text"".

For the Responsibility part: Three sentences about my main responsibilities - what I do, what I know.

For the Collaborators Part: State my main collaborators and one line about how I interact with them. 

Public API and Key Messages

- message one   
- message two 
- (for bonus points) how to create instances.

   One simple example is simply gorgeous.
 
Internal Representation and Key Implementation Points.

    Instance Variables
	noteBook:		<Object>
	sourceCodePage:		<Object>
	sourceText:		<Object>


    Implementation Points
"
Class {
	#name : #MiFilesBrowser,
	#superclass : #MiAbstractFamixBrowser,
	#instVars : [
		'tree',
		'list'
	],
	#category : #'Midas-Famix-FilesBrowser'
}

{ #category : #specs }
MiFilesBrowser class >> defaultSpec [
	^ SpBoxLayout newHorizontal
		add: #tree;
		add: #list;
		yourself
]

{ #category : #specs }
MiFilesBrowser class >> menuCommandOn: aBuilder [
	<worldMenu>
	(aBuilder item: #FilesBrowser)
		parent: self toolbarFamixName;
		label: 'Files browser';
		action: [ self runMe ]
]

{ #category : #specs }
MiFilesBrowser class >> runMe [
	<script>
	self new openWithSpec
]

{ #category : #'as yet unclassified' }
MiFilesBrowser >> accept: anObject [
	^ (anObject isKindOf: MooseModel) and: [ anObject rootFolder isNotNil and: [ anObject rootFolder asFileReference exists ]  ]
]

{ #category : #'as yet unclassified' }
MiFilesBrowser >> computeItemsInFileReference: aFileReference [
	"isChildOf: can bug see issue https://github.com/pharo-project/pharo/issues/5720"
	^ (self model mooseModel allUsing: FamixTFileAnchor) select: [ :anchor | 1halt. anchor fileReference isChildOf: self model fileReference ] thenCollect: [ :anchor | anchor element ]
]

{ #category : #'as yet unclassified' }
MiFilesBrowser >> connectPresenters [
	super connectPresenters.
	tree whenSelectionChangedDo: [ :selected | selected selectedItem hasChildren ifTrue: [ self selectFileReference: selected selectedItem.
			list items: (self computeItemsInFileReference: self model fileReference) ] ]
]

{ #category : #'as yet unclassified' }
MiFilesBrowser >> initializePresenters [
	self model: MiFilesModel new.
	self initializeTreeTable.
	list := self newList.
]

{ #category : #'as yet unclassified' }
MiFilesBrowser >> initializeTreeTable [
	tree := self newTable.
	tree
		addColumn:
			(SpCompositeTableColumn new
				addColumn: (SpStringTableColumn evaluated: [ :fileRef | (fileRef isChildOf: self model fileReference) ifTrue: [ fileRef basename ] ifFalse: [ '..' ] ]);
				yourself);
		beResizable
]

{ #category : #'as yet unclassified' }
MiFilesBrowser >> refresh [
	tree items: {self model fileReference parent} , self model fileReference directories , self model fileReference files
]

{ #category : #'as yet unclassified' }
MiFilesBrowser >> selectEntity: anEntity [
	(self accept: anEntity)
		ifFalse: [ ^ self ].
	self model mooseModel: anEntity.
	self selectFileReference: anEntity rootFolder asFileReference
]

{ #category : #'as yet unclassified' }
MiFilesBrowser >> selectFileReference: aFileReference [
	self model fileReference: aFileReference.
	self refresh
]

{ #category : #'as yet unclassified' }
MiFilesBrowser >> title [
	^ 'Files Browser'
]
