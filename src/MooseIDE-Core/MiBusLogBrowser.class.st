"
I am a browser displaying logs for a specific bus. I am used by the overview browser as a browser and by the logs browser as a presenter in a notebook.

Accepted entities: Does not apply.
"
Class {
	#name : #MiBusLogBrowser,
	#superclass : #MiAbstractBrowser,
	#instVars : [
		'list',
		'localToolbar',
		'localToolbarCommandGroup'
	],
	#category : #'MooseIDE-Core-Logger'
}

{ #category : #adding }
MiBusLogBrowser class >> addToMiBrowsersMenu: aMenuGroupPresenter [

	"Do not appear in menu"

	
]

{ #category : #'instance creation' }
MiBusLogBrowser class >> forBus: aBus application: anApplication [

	^ (self newApplication: anApplication)
		  followBus: aBus;
		  yourself
]

{ #category : #commands }
MiBusLogBrowser class >> localToolbarCommandsGroupFor: aPresenter [

	^ CmCommandGroup forSpec
		  register: (MiLoggerClearLogsCommand forSpecContext: aPresenter);
		  register: (self propagateCommandFor: aPresenter);
		  register: (MiLoggerRemoveLogCommand forSpecContext: aPresenter)
				  beDisplayedOnRightSide
]

{ #category : #commands }
MiBusLogBrowser class >> menuCommandGroupFor: presenter [

	^ CmCommandGroup forSpec beRoot
		  register: (MiInspectCommand forSpecContext: presenter);
		  register: (self propagateCommandFor: presenter);
		  register: (MiLoggerRemoveLogCommand forSpecContext: presenter)
]

{ #category : #'instance creation' }
MiBusLogBrowser class >> openForBus: aBus application: anApplication [

	| busLogPresenter |
	busLogPresenter := (self forBus: aBus application: anApplication)
		                   open;
		                   updateToolbars;
		                   yourself.
	busLogPresenter owner title: 'Logs of bus: ' , aBus name.
	^ busLogPresenter
]

{ #category : #'instance creation' }
MiBusLogBrowser class >> openForTests: anApplication [

	| busLogPresenter |
	busLogPresenter := (self forBus: anApplication defaultBus application: anApplication)
		                   open;
		                   updateToolbars;
		                   yourself.
	busLogPresenter owner title: 'Logs of bus: ' , anApplication defaultBus name.
	^ busLogPresenter
]

{ #category : #commands }
MiBusLogBrowser class >> propagateCommandFor: presenter [

	| propagateOnThisBus |
	propagateOnThisBus := (MiPropagateCommand forContext: presenter)
		                      doNotFreezeBrowser;
		                      asSpecCommand.
	propagateOnThisBus
		beDisplayedOnRightSide;
		name: 'Propagate on this bus'.
	^ propagateOnThisBus
]

{ #category : #testing }
MiBusLogBrowser >> canEditBuses [

	^ false
]

{ #category : #testing }
MiBusLogBrowser >> canFollowEntity: anObject [

	^ true
]

{ #category : #testing }
MiBusLogBrowser >> canTagEntities [

	^false
]

{ #category : #actions }
MiBusLogBrowser >> clearLogs [

	self logger clean.
	self updateList
]

{ #category : #actions }
MiBusLogBrowser >> followEntity: anEntity [

	self updateList
]

{ #category : #initialization }
MiBusLogBrowser >> initializePresenters [

	self layout: (SpBoxLayout newTopToBottom
			 add: (localToolbar := self newToolbar) expand: false;
			 add: (list := self newList);
			 yourself).

	localToolbar fillWith: self localToolbarCommandGroup.

	list
		display: [ :log | log entity mooseName ];
		contextMenu: [ self menuCommandGroup asMenuPresenter ];
		whenSelectedDo: [ :log | self updateToolbars ]
]

{ #category : #commandGroups }
MiBusLogBrowser >> localToolbarCommandGroup [

	^ localToolbarCommandGroup ifNil: [ 
		  localToolbarCommandGroup := self class 
			                              localToolbarCommandsGroupFor: self ]
]

{ #category : #accessing }
MiBusLogBrowser >> logger [

	^ self buses anyOne logger
]

{ #category : #commandGroups }
MiBusLogBrowser >> menuCommandGroup [

	^ self class menuCommandGroupFor: self
]

{ #category : #accessing }
MiBusLogBrowser >> miSelectedItem [

	^ list selectedItem ifNotNil: [ :log | log entity ]
]

{ #category : #actions }
MiBusLogBrowser >> removeSelectedLog [

	self logger removeLog: list selectedItem.
	self updateList
]

{ #category : #updating }
MiBusLogBrowser >> updateList [

	| logs |
	logs := self logger logs.

	list items: logs.

	logs
		ifEmpty: [ self updateToolbars ]
		ifNotEmpty: [ list selectFirst ]
]

{ #category : #updating }
MiBusLogBrowser >> updateLocalToolbar [

	self localToolbarCommandGroup allCommands do: [ :cmd | 
		cmd updateEnableStatus ]
]

{ #category : #updating }
MiBusLogBrowser >> updateToolbars [

	self updateLocalToolbar.
	self updateToolbar
]
