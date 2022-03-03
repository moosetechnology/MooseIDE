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

{ #category : #testing }
MiPresenter >> isMiBrowser [
	^ false
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
