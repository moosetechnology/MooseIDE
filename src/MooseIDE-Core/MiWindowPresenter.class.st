Class {
	#name : #MiWindowPresenter,
	#superclass : #SpWindowPresenter,
	#instVars : [
		'menuButton'
	],
	#category : #'MooseIDE-Core-Browser'
}

{ #category : #initialization }
MiWindowPresenter >> buildBusesMenu [

	^ menuButton := ((MiEditBusCommand forSpecContext: presenter) 
		                 configureAsButtonOfClass:
		                 SpToolbarPopoverButtonPresenter) buildPresenter 
		                content: (MiBusesPopup on: presenter)
]

{ #category : #initialization }
MiWindowPresenter >> buildToolbar [

	self toolbar: self newToolbar.
	MiFollowMode newButtonIn: toolbar forBrowser: presenter.
	MiFreezeMode newButtonIn: toolbar forBrowser: presenter.
	MiHighlightMode newButtonIn: toolbar forBrowser: presenter.
	toolbar
		addItemRight:
			(MiHelpCommand forSpecContext: presenter) configureAsToolbarButton
				buildPresenter;
		addItemRight: (MiPropagateCommand forSpecContext: presenter)
				configureAsToolbarButton buildPresenter;
		addItemRight:
			(MiInspectCommand forSpecContext: presenter)
				configureAsToolbarButton buildPresenter;
		addItem: self buildBusesMenu
]

{ #category : #private }
MiWindowPresenter >> defaultInitialExtent [

	^ 500 @ 400
]
