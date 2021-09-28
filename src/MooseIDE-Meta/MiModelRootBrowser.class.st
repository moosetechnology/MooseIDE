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
	#superclass : #MiAbstractBrowser,
	#instVars : [
		'toolbar',
		'modelFilteringList'
	],
	#category : #'MooseIDE-Meta-ModelRootBrowser'
}

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

{ #category : #specs }
MiModelRootBrowser class >> defaultSpec [

	^ super defaultSpec
		  add: #toolbar
		  withConstraints: [ :constraints | 
			  constraints height: self toolbarHeight ];
		  add: #modelFilteringList;
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
		action: [ self open ]
]

{ #category : #'instance creation' }
MiModelRootBrowser class >> newModel [
	^ MiModelRootBrowserModel new
]

{ #category : #specs }
MiModelRootBrowser class >> open [
	<script>
	^ super open
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
MiModelRootBrowser >> canReceiveEntity: anObject [
	^ false
]

{ #category : #actions }
MiModelRootBrowser >> followEntity: anEntity [

	"Nothing to do"

	
]

{ #category : #initialization }
MiModelRootBrowser >> initializeList [

	modelFilteringList := self newFilteringList
		                      items: MooseModel root;
		                      display: [ :mooseModel | mooseModel name ];
		                      yourself.
	modelFilteringList listPresenter
		contextMenu: [ 
			(self class buildModelCommandsGroupWith: self) asMenuPresenter ];
		whenSelectionChangedDo: [ :selected | 
			model selected: selected selectedItem.
			self updateToolbar ]
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

	^ modelFilteringList selectedItem
]

{ #category : #initialization }
MiModelRootBrowser >> refreshToolbarButton [

	^ SpToolbarButtonPresenter new
		  icon: (self iconNamed: #smallUpdate);
		  help: 'Refresh list';
		  action: [ modelFilteringList listPresenter updateList ];
		  yourself
]

{ #category : #accessing }
MiModelRootBrowser >> selected [
	^ model selected
]

{ #category : #accessing }
MiModelRootBrowser >> selectedObject [

	^ modelFilteringList selectedItem
]

{ #category : #updating }
MiModelRootBrowser >> updateForNewModel: aModel [

	self class updateAll.
	modelFilteringList selectItem: aModel.
	self updateToolbar
]

{ #category : #updating }
MiModelRootBrowser >> updateList [

	self freezeDuring: [ 
		| selected |
		selected := self selected.
		modelFilteringList listPresenter updateList.
		modelFilteringList selectItem: selected ]
]
