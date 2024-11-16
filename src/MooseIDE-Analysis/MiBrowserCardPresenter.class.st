Class {
	#name : #MiBrowserCardPresenter,
	#superclass : #MiPresenter,
	#instVars : [
		'browser',
		'titleLabel',
		'buttons'
	],
	#category : #'MooseIDE-Analysis'
}

{ #category : #commands }
MiBrowserCardPresenter class >> buildCommandsGroupWith: aPresenter forRoot: rootCommandGroup [

	rootCommandGroup
		register:
			(MiAnalysisPropagateLocallyCommand forSpecContext: aPresenter);
		register: (MiInspectCommand forSpecContext: aPresenter browser);
		register: (MiAnalysisCloseBrowserCommand forSpecContext: aPresenter);
		register: (MiHelpCommand forSpecContext: aPresenter browser)
]

{ #category : #'as yet unclassified' }
MiBrowserCardPresenter >> analysisBrowser [

	^ owner owner
]

{ #category : #accessing }
MiBrowserCardPresenter >> browser [

	^ browser
]

{ #category : #'as yet unclassified' }
MiBrowserCardPresenter >> closeBrowser [

	self analysisBrowser remove: browser
]

{ #category : #layout }
MiBrowserCardPresenter >> defaultLayout [

	^ self newBoxLayoutLeftToRight
		  vAlignCenter;
		  add: titleLabel;
		  add: buttons expand: false;
		  yourself
]

{ #category : #initialization }
MiBrowserCardPresenter >> initializePresenters [

	super initializePresenters.
	titleLabel := self newLabel
		              label: browser title;
		              help: browser miSelectedItem asString;
		              yourself.

	buttons := self newToolbar
		           fillWith: self rootCommandsGroup;
		           beIcons
]

{ #category : #'as yet unclassified' }
MiBrowserCardPresenter >> propagateLocally [

	self analysisBrowser propagateLocallyFrom: browser
]

{ #category : #'accessing - model' }
MiBrowserCardPresenter >> setModelBeforeInitialization: aBrowser [

	browser := aBrowser
]
