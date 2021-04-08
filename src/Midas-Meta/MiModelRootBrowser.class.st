"
** Midas entrypoint **
Shows installed models and allows model installation.

- Follow: Nothing to do.
- Highlight: <TODO> Could highlight the model containing the received entity.
- Propagate: The selected model.

<TODO> Add features available in MoosePanel.
"
Class {
	#name : #MiModelRootBrowser,
	#superclass : #MiAbstractBrowser,
	#instVars : [
		'modelPresenter',
		'toolbar'
	],
	#category : #'Midas-Meta-ModelRootBrowser'
}

{ #category : #'world menu' }
MiModelRootBrowser class >> buildCommandsGroupWith: presenterInstance forRoot: rootCommandGroup [
	super
		buildCommandsGroupWith: presenterInstance
		forRoot: rootCommandGroup.
	rootCommandGroup
		register: (MiModelExportCommand asCommandGroupWith: presenterInstance);
		register: (MiModelUtilityCommand asCommandGroupWith: presenterInstance)
]

{ #category : #specs }
MiModelRootBrowser class >> defaultSpec [
	^ super defaultSpec
		add: #toolbar withConstraints: [ :constraints | constraints height: self toolbarHeight ];
		add: #modelPresenter;
		yourself
]

{ #category : #specs }
MiModelRootBrowser class >> menuCommandOn: aBuilder [
	<worldMenu>
	<miBrowsers>
	(aBuilder item: #ModelRootBrowser)
		parent: #Moose ;
		label: self title ;
		icon: (self iconNamed: #mooseNavigation) ;
		order: 2 ;
		help: self helpMessage ;
		action: [ self runMe ]
]

{ #category : #'instance creation' }
MiModelRootBrowser class >> newModel [
	^ MiModelRootBrowserModel new
]

{ #category : #specs }
MiModelRootBrowser class >> runMe [
	<script>
	^ super runMe
]

{ #category : #initialization }
MiModelRootBrowser class >> title [
	^ 'Models browser'
]

{ #category : #'updating screen' }
MiModelRootBrowser class >> updateAll [
	self allInstances
		select: [ :browser | browser window isOpen ]
		thenDo: [ :browser | browser updateList ]
]

{ #category : #specs }
MiModelRootBrowser class >> windowSize [
	^ 600 @ 400
]

{ #category : #testing }
MiModelRootBrowser >> accept: anObject [
	^ false
]

{ #category : #actions }
MiModelRootBrowser >> followAction [
	^ self
]

{ #category : #initialization }
MiModelRootBrowser >> initializeList [
	modelPresenter := self newList
		items: MooseModel root;
		display: [ :mooseModel | mooseModel name ];
		contextMenu: [ self rootCommandsGroup asMenuPresenter ];
		whenSelectionChangedDo: [ :selected | 
			model selected: selected selectedItem.
			self isFreeze
				ifFalse:
					[ self buses do: [ :bus | bus globallySelect: selected selectedItem ] ] ]
]

{ #category : #initialization }
MiModelRootBrowser >> initializePresenters [
	super initializePresenters.
	self initializeToolbar.
	self initializeList
]

{ #category : #initialization }
MiModelRootBrowser >> initializeToolbar [

	toolbar := (MPImportCommand asCommandGroupForSpecContext: self)
		        asToolbarPresenter beIcons.
	toolbar addItem: self refreshToolbarButton
]

{ #category : #accessing }
MiModelRootBrowser >> miSelectedItem [
	^ modelPresenter selection selectedItem
]

{ #category : #accessing }
MiModelRootBrowser >> modelPresenter [
	^ modelPresenter
]

{ #category : #initialization }
MiModelRootBrowser >> refreshToolbarButton [

	^ SpToolbarButtonPresenter new
		  icon: (self iconNamed: #smallUpdate);
		  help: 'Refresh list';
		  action: [ modelPresenter updateList ];
		  yourself
]

{ #category : #accessing }
MiModelRootBrowser >> selected [
	^ model selected
]

{ #category : #accessing }
MiModelRootBrowser >> selectedObject [
	^ modelPresenter selection selectedItem
]

{ #category : #updating }
MiModelRootBrowser >> updateForNewModel: aModel [

	self class updateAll.
	modelPresenter selectItem: aModel
]

{ #category : #updating }
MiModelRootBrowser >> updateList [
	self
		freezeDuring: [ | selected |
			selected := self selected.
			modelPresenter updateList.
			modelPresenter selectItem: selected ]
]
