"
** Moose IDE entrypoint **
Shows installed models and allows model installation.

- Follow: Nothing to do.
- Highlight: <TODO> Could highlight the model containing the received entity.
- Propagate: The selected model.

<TODO> Add features available in MoosePanel.
"
Class {
	#name : #MiModelRootBrowser,
	#superclass : #MiAbstractBrowser2,
	#instVars : [
		'toolbar',
		'modelFilteringList'
	],
	#category : #'MooseIDE-Meta-ModelRootBrowser'
}

{ #category : #menu }
MiModelRootBrowser class >> addItemOrSubMenuToMiBrowsersMenu: aRootMenu defaultSubMenu: aSubMenu [

	self addToMiBrowsersMenu: aRootMenu
]

{ #category : #'world menu' }
MiModelRootBrowser class >> buildModelCommandsGroupWith: presenterInstance [

	^ CmCommandGroup forSpec beRoot
		  register: (MiInspectCommand forSpecContext: presenterInstance);
		  register: (MiPropagateCommand forSpecContext: presenterInstance);
		  register:
			  (MiModelExportCommand asCommandGroupWith: presenterInstance);
		  register:
			  (MiModelUtilityCommand asCommandGroupWith: presenterInstance)
]

{ #category : #layout }
MiModelRootBrowser class >> defaultLayout [

	^ super defaultLayout
		  add: #toolbar
		  withConstraints: [ :constraints | 
			  constraints height: self toolbarHeight ];
		  add: #modelFilteringList;
		  yourself
]

{ #category : #'world menu' }
MiModelRootBrowser class >> menuCommandOn: aBuilder [
	<worldMenu>
	<miBrowsers>
	(aBuilder item: #ModelRootBrowser)
		parent: #Moose ;
		label: self title ;
		icon: (self iconNamed: self menuIconName) ;
		order: self menuPriority ;
		help: self helpMessage ;
		action: [ self open ]
]

{ #category : #menu }
MiModelRootBrowser class >> menuIconName [

	^ #mooseNavigation
]

{ #category : #menu }
MiModelRootBrowser class >> menuPriority [

	^ 2
]

{ #category : #'instance creation' }
MiModelRootBrowser class >> newModel [
	^ MiModelRootBrowserModel new
]

{ #category : #'instance creation' }
MiModelRootBrowser class >> open [
	<script>
	^ super open
]

{ #category : #specs }
MiModelRootBrowser class >> title [
	^ 'Models browser'
]

{ #category : #specs }
MiModelRootBrowser class >> windowSize [
	^ 600 @ 400
]

{ #category : #testing }
MiModelRootBrowser >> canFollowEntity: anObject [
	^ false
]

{ #category : #testing }
MiModelRootBrowser >> canPropagate [

	^ model canPropagate
]

{ #category : #actions }
MiModelRootBrowser >> followEntity: anEntity [

	"Nothing to do"

	
]

{ #category : #testing }
MiModelRootBrowser >> hasSettings [
	^ true
]

{ #category : #initialization }
MiModelRootBrowser >> initializeList [

	modelFilteringList := self newFilteringList.
	self listOfMooseModels: model mooseModelsList.

	modelFilteringList display: [ :mooseModel | mooseModel name ].

	modelFilteringList listPresenter contextMenu: [ 
		(self class buildModelCommandsGroupWith: self) asMenuPresenter ].

	modelFilteringList whenSelectionChangedDo: [ :selected | 
		model selected: selected selectedItem.
		self sendEntitiesToPrivateBus.
		self updateToolbar ].
	modelFilteringList items ifNotEmpty: [ :models | 
		modelFilteringList selectItem: models first ]
]

{ #category : #initialization }
MiModelRootBrowser >> initializePresenters [

	self initializeToolbar.
	self initializeList
]

{ #category : #initialization }
MiModelRootBrowser >> initializeToolbar [

	toolbar := (MiImportCommand asCommandGroupForSpecContext: self)
		           asToolbarPresenter beIcons.
	toolbar addItem: self refreshToolbarButton
]

{ #category : #updating }
MiModelRootBrowser >> listOfMooseModels: aList [

	modelFilteringList items: aList
]

{ #category : #accessing }
MiModelRootBrowser >> miSelectedItem [

	^ model selected
]

{ #category : #'accessing - tests' }
MiModelRootBrowser >> modelFilteringList [
	^ modelFilteringList
]

{ #category : #initialization }
MiModelRootBrowser >> refreshToolbarButton [

	^ SpToolbarButtonPresenter new
		  icon: (self iconNamed: #smallUpdate);
		  help: 'Refresh list';
		  action: [ modelFilteringList listPresenter updateList ];
		  yourself
]

{ #category : #'accessing - model' }
MiModelRootBrowser >> setModelBeforeInitialization: aModel [
	super setModelBeforeInitialization: aModel.
	aModel browser: self
]

{ #category : #actions }
MiModelRootBrowser >> settings [

	model openSettings
]

{ #category : #'accessing - tests' }
MiModelRootBrowser >> settingsItem [
	^ model settings
]

{ #category : #updating }
MiModelRootBrowser >> updateForNewModel: aModel [

	model updateForNewModel: aModel.
	self sendEntitiesToPrivateBus
]

{ #category : #updating }
MiModelRootBrowser >> updateList [

	| selectedItem |
	selectedItem := model rawSelectedMooseModel.
	model updateMooseModelsList.

	modelFilteringList items: model mooseModelsList.

	modelFilteringList selectItem: (selectedItem
			 ifNotNil: [ selectedItem ]
			 ifNil: [ model mooseModelsList at: 1 ifAbsent: [ nil ] ])
]
