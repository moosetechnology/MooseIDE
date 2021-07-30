"
Root folder explorer.
Allows to explore the root folder of a model (left panel) and shows the entities contained in each file (right panel).

- Follow: Receives a MooseModel that has a root folder
- Highlight: <TODO>
  Entities if present and visible.
  Could highlight the file owning a received entity.
- Propagate: <TODO>
"
Class {
	#name : #MiFilesBrowser,
	#superclass : #MiAbstractFamixBrowser,
	#instVars : [
		'tree',
		'treeEntity'
	],
	#category : #'MooseIDE-Famix-FilesBrowser'
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
	<miBrowsers>
	(aBuilder item: #FilesBrowser)
		parent: (self toolbarFamixName);
		label: (self title);
		icon: (self iconNamed: #mooseFolder);
		help: (self helpMessage);
		order: 3;
		action: [ self runMe ]
]

{ #category : #initialization }
MiFilesBrowser class >> newModel [
	^ MiFilesModel new
]

{ #category : #specs }
MiFilesBrowser class >> runMe [
	<script>
	^ super runMe
]

{ #category : #TOREMOVE }
MiFilesBrowser class >> title [
	^ 'Files'
]

{ #category : #testing }
MiFilesBrowser >> accept: anObject [
	^ (anObject isKindOf: MooseModel) and:
	 [ anObject rootFolder isNotNil and:
	 [ anObject rootFolder asFileReference exists ]  ]
]

{ #category : #actions }
MiFilesBrowser >> canHighlight [
	^false
]

{ #category : #'as yet unclassified' }
MiFilesBrowser >> computeItemsInFileReference: aFileReference [
	"isChildOf: can bug see issue https://github.com/pharo-project/pharo/issues/5720"

	^ (self model mooseModel allUsing: FamixTFileAnchor)
		select: [ :anchor | anchor element isClass and: [ anchor element isAnonymousClass not and: [ anchor fileReference canonicalize isChildOf: self model fileReference ] ] ]
		thenCollect: [ :anchor | anchor element ]
]

{ #category : #initialization }
MiFilesBrowser >> connectPresenters [
	super connectPresenters.
	tree whenSelectionChangedDo: [ :selected |
		( selected selectedItem isNotNil and: 
		[ selected selectedItem hasChildren] ) 
			ifTrue: [
				self selectFileReference: selected selectedItem.
				treeEntity roots: (self computeItemsInFileReference: self model fileReference) ] ] 
]

{ #category : #actions }
MiFilesBrowser >> followAction [
	(self accept: toSelect)
		ifFalse: [ ^ self ].
	self model mooseModel: toSelect.
	self selectFileReference: toSelect rootFolder asFileReference.
	self updateWindowTitle
]

{ #category : #initialization }
MiFilesBrowser >> initializePresenters [
	super initializePresenters.
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
			selected selectedItems
				ifNotEmpty: [ self
						freezeDuring: [ selected selectedItems size = 1
								ifTrue: [ self buses do: [ :bus | bus globallySelect: selected selectedItem ] ]
								ifFalse: [ | mooseGroup |
									mooseGroup := MooseGroup withAll: selected selectedItems.
									self buses do: [ :bus | bus globallySelect: mooseGroup ] ] ] ] ]
]

{ #category : #initialization }
MiFilesBrowser >> initializeTreeTable [
	tree := self newTable.
	tree
		addColumn:
			(SpCompositeTableColumn new
				addColumn:
					(SpStringTableColumn evaluated: [ :fileRef |
						(fileRef isChildOf: self model fileReference)
							ifTrue: [ fileRef basename ] ifFalse: [ '..' ] ]);
				yourself);
		beResizable
]

{ #category : #refreshing }
MiFilesBrowser >> refresh [
	tree items: {self model fileReference parent} , self model fileReference directories , self model fileReference files
]

{ #category : #'as yet unclassified' }
MiFilesBrowser >> selectFileReference: aFileReference [
	self model fileReference: aFileReference.
	self refresh
]

{ #category : #refreshing }
MiFilesBrowser >> updateWindowTitle [
	self
		withWindowDo: [ :window | 
			window
				title: self class title , ' of ' , self model mooseModel name , ' model' ]
]
