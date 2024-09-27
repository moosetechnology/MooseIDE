Class {
	#name : #MiAnalysisPresenter,
	#superclass : #MiAbstractBrowser,
	#instVars : [
		'browsersLists',
		'currentBrowser',
		'browserLayout'
	],
	#category : #'MooseIDE-Analysis'
}

{ #category : #specs }
MiAnalysisPresenter class >> title [

	^ 'Moose Analysis'
]

{ #category : #specs }
MiAnalysisPresenter class >> windowSize [

	^ 600 @ 400
]

{ #category : #testing }
MiAnalysisPresenter >> canFollowEntity: anObject [

	^ currentBrowser canFollowEntity: anObject
]

{ #category : #layout }
MiAnalysisPresenter >> defaultLayout [

	^ SpPanedLayout newLeftToRight
		  positionOfSlider: 0.3;
		  add: browsersLists;
		  add: (browserLayout := self newBoxLayoutTopToBottom);
		  yourself
]

{ #category : #initialization }
MiAnalysisPresenter >> initialize [

	super initialize.
	self whenDisplayDo: [ browsersLists selectIndex: 1 ]
]

{ #category : #initialization }
MiAnalysisPresenter >> initializePresenters [

	super initializePresenters.

	browsersLists := self newComponentList.
	browsersLists
		items: {
				(self newBrowser: MiModelsBrowser).
				(self newBrowser: MiTagBrowser) };
		whenSelectedItemChangedDo: [ :browserCard |
			self selectedBrowserChanged: browserCard browser ]
]

{ #category : #accessing }
MiAnalysisPresenter >> miSelectedItem [

	^ currentBrowser miSelectedItem
]

{ #category : #accessing }
MiAnalysisPresenter >> miSelectedItemToPropagate [

	^ currentBrowser miSelectedItemToPropagate
]

{ #category : #initialization }
MiAnalysisPresenter >> newBrowser: aBrowserClass [

	^ MiBrowserCardPresenter on:
		  ((aBrowserClass on: aBrowserClass newModel)
			   owner: self;
			   yourself)
]

{ #category : #initialization }
MiAnalysisPresenter >> newModelsBrowser [

	^ MiModelsBrowser on: MiModelsBrowserModel
]

{ #category : #initialization }
MiAnalysisPresenter >> selectedBrowserChanged: aBrowser [

	currentBrowser := aBrowser.

	browserLayout
		removeAll;
		add: currentBrowser.

	self updateToolbar
]
