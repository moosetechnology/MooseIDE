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
		'treeEntity'
	],
	#category : #'Midas-Famix-FilesBrowser'
}

{ #category : #specs }
MiFilesBrowser class >> defaultSpec [
	^ super defaultSpec
		add:
			(SpBoxLayout newHorizontal
				add: #tree;
				add: #treeEntity;
				yourself);
		yourself
]

{ #category : #specs }
MiFilesBrowser class >> menuCommandOn: aBuilder [
	<worldMenu>
	(aBuilder item: #FilesBrowser)
		parent: self toolbarFamixName;
		label: 'Files browser';
		icon: (self iconNamed: #mooseFolder);
		order: 3.0;
		action: [ self runMe ]
]

{ #category : #specs }
MiFilesBrowser class >> runMe [
	<script>
	super runMe
]

{ #category : #'as yet unclassified' }
MiFilesBrowser >> accept: anObject [
	^ (anObject isKindOf: MooseModel) and: [ anObject rootFolder isNotNil and: [ anObject rootFolder asFileReference exists ]  ]
]

{ #category : #'as yet unclassified' }
MiFilesBrowser >> computeItemsInFileReference: aFileReference [
	"isChildOf: can bug see issue https://github.com/pharo-project/pharo/issues/5720"

	^ (self model mooseModel allUsing: FamixTFileAnchor)
		select: [ :anchor | anchor element isClass and: [ anchor element isAnonymousClass not and: [ anchor fileReference canonicalize isChildOf: self model fileReference ] ] ]
		thenCollect: [ :anchor | anchor element ]
]

{ #category : #'as yet unclassified' }
MiFilesBrowser >> connectPresenters [
	super connectPresenters.
	tree whenSelectionChangedDo: [ :selected | (selected selectedItem isNotNil and: [  selected selectedItem hasChildren ]) ifTrue: [ self selectFileReference: selected selectedItem.
			treeEntity roots: (self computeItemsInFileReference: self model fileReference) ] ] 
]

{ #category : #'as yet unclassified' }
MiFilesBrowser >> followAction [
	(self accept: toSelect)
		ifFalse: [ ^ self ].
	self model mooseModel: toSelect.
	self selectFileReference: toSelect rootFolder asFileReference
]

{ #category : #'as yet unclassified' }
MiFilesBrowser >> initializePresenters [
	super initializePresenters.
	self model: MiFilesModel new.
	self initializeTreeTable.
	treeEntity := self newTreeTable.
	treeEntity
		addColumn:
			(SpCompositeTableColumn new
				addColumn:
					((SpImageTableColumn evaluated: #midasIcon)
						width: 20;
						yourself);
				addColumn: (SpStringTableColumn evaluated: #name);
				yourself);
		children: [ :aClass | aClass children asOrderedCollection ];
		beMultipleSelection;
		beResizable.
	treeEntity
		whenSelectionChangedDo: [ :selected | 
			selected selectedItems ifNotEmpty: [ 
			self
				freezeDuring: [ selected selectedItems size = 1
						ifTrue: [
							MiApplication current globallySelect: selected selectedItem ]
						ifFalse: [ | mooseGroup |
							mooseGroup := MooseGroup withAll: selected selectedItems.
							MiApplication current globallySelect: mooseGroup ] ] ] ]
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
MiFilesBrowser >> selectFileReference: aFileReference [
	self model fileReference: aFileReference.
	self refresh
]

{ #category : #'as yet unclassified' }
MiFilesBrowser >> title [
	^ 'Files Browser'
]
