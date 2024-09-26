Class {
	#name : #MiPresenter,
	#superclass : #SpPresenter,
	#category : #'MooseIDE-Core-Browser'
}

{ #category : #accessing }
MiPresenter class >> currentApplication [

	^ MiApplication current
]

{ #category : #accessing }
MiPresenter class >> iconNamed: aName [

	^ self currentApplication iconNamed: aName
]

{ #category : #'instance creation' }
MiPresenter class >> new [

	^ self newApplication: self currentApplication
]

{ #category : #specs }
MiPresenter class >> tableLineHeight [
	^ self labelHeight + 5
]

{ #category : #actions }
MiPresenter >> helpPopoverSource [

	^ self window toolbar rightItems first
]

{ #category : #actions }
MiPresenter >> helpText [
	"Override when necessary"

	^ self class comment
]

{ #category : #testing }
MiPresenter >> isMiBrowser [
	^ false
]

{ #category : #'scripting - widgets' }
MiPresenter >> newMooseGroupsTreeTable [

	^ self instantiate: MiMooseGroupsTreeTablePresenter
]

{ #category : #'scripting - widgets' }
MiPresenter >> newSelectableListForPopoverExtent: aPoint [

	^ SpFilteringSelectableListPresenter new
		  layout: (self newBoxLayoutTopToBottom
				   add: SpFilteringSelectableListPresenter defaultLayout
				   withConstraints: [ :c | 
					   c
						   height: aPoint x;
						   width: aPoint y ];
				   yourself);
		  yourself
]

{ #category : #accessing }
MiPresenter >> rootBrowser [

	^ self isMiBrowser
		  ifTrue: [ self ]
		  ifFalse: [ self owner rootBrowser ]
]

{ #category : #actions }
MiPresenter >> showHelp [

	| innerTextPresenter |
	innerTextPresenter := self newText
		                      text: self helpText;
		                      beNotEditable;
		                      addStyle: 'help';
		                      yourself.

	innerTextPresenter eventHandler whenFocusLostDo: [
		innerTextPresenter owner dismiss ].

	^ self newPopover
		  relativeTo: self helpPopoverSource;
		  bePositionLeft;
		  presenter: innerTextPresenter;
		  popup
]
