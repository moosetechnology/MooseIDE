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

{ #category : #'instance creation' }
MiBusLogBrowser class >> forBus: aBus [

	^ self new followBus: aBus
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
MiBusLogBrowser class >> openForBus: aBus [

	^ (self forBus: aBus)
		  open;
		  updateToolbars;
		  yourself
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

{ #category : #actions }
MiBusLogBrowser >> clearLogs [

	self logger clean.
	self updateList
]

{ #category : #buses }
MiBusLogBrowser >> followBus: aBus [

	super followBus: aBus.
	self ifAutonomous: [ 
		self window title: 'Logs of bus: ' , buses anyOne name ]
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
