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

{ #category : #layout }
MiFilesBrowser class >> defaultLayout [
	^ super defaultLayout
		add:
			(SpBoxLayout newHorizontal
				add: #tree;
				add: #treeEntity;
				yourself);
		yourself
]

{ #category : #'world menu' }
MiFilesBrowser class >> menuCommandOn: aBuilder [
	<worldMenu>
	<miBrowsers>
	(aBuilder item: #FilesBrowser)
		parent: (self toolbarFamixName);
		label: (self title);
		icon: (self iconNamed: #mooseFolder);
		help: (self helpMessage);
		order: 3;
		action: [ self open ]
]

{ #category : #'instance creation' }
MiFilesBrowser class >> newModel [
	^ MiFilesModel new
]

{ #category : #'instance creation' }
MiFilesBrowser class >> open [
	<script>
	^ super open
]

{ #category : #specs }
MiFilesBrowser class >> title [
	^ 'Files'
]

{ #category : #testing }
MiFilesBrowser >> canFollowEntity: anObject [

	^ anObject isMooseObject and: [ 
		  anObject isMooseModel and: [ 
			  anObject rootFolder isNotNil and: [ 
				  anObject rootFolder asFileReference exists ] ] ]
]

{ #category : #initialization }
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
MiFilesBrowser >> followEntity: anEntity [

	self model mooseModel: anEntity.
	self selectFileReference: anEntity rootFolder asFileReference.
	self updateWindowTitle
]

{ #category : #initialization }
MiFilesBrowser >> initializePresenters [

	self initializeTreeTable.
	treeEntity := self newTreeTable.
	treeEntity
		addColumn: (SpCompositeTableColumn new
				 addColumn: ((SpImageTableColumn evaluated: #midasIcon)
						  width: 20;
						  yourself);
				 addColumn: (SpStringTableColumn evaluated: #name);
				 yourself);
		children: [ :aClass | aClass children asOrderedCollection ];
		beMultipleSelection;
		beResizable.
	treeEntity whenSelectionChangedDo: [ :selected | 
		selected selectedItems ifNotEmpty: [ 
			self freezeDuring: [ 
				selected selectedItems size = 1
					ifTrue: [ 
					self buses do: [ :bus | 
						bus globallySelect: selected selectedItem ] ]
					ifFalse: [ 
						| mooseGroup |
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

{ #category : #accessing }
MiFilesBrowser >> miSelectedItem [

	^ model mooseModel
]

{ #category : #refreshing }
MiFilesBrowser >> refresh [

	tree items: { self model fileReference parent }
		, self model fileReference directories
		, self model fileReference files
]

{ #category : #actions }
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
