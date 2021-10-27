"
I am an empty presenter that will not do anything. I am only for avoiding checking for nil
"
Class {
	#name : #MiNullQueryPresenter,
	#superclass : #MiQueryConfiguratorPresenter,
	#category : #'MooseIDE-QueriesBrowser-Configuration presenters'
}

{ #category : #actions }
MiNullQueryPresenter >> computeQuery: anObject [
]

{ #category : #'api - actions' }
MiNullQueryPresenter >> configureFor: aQuery [
]

{ #category : #initialization }
MiNullQueryPresenter >> initialize [

	super initialize.
	query := FQNullQuery new
]

{ #category : #initialization }
MiNullQueryPresenter >> initializePresenters [

	self initializeLayout
]

{ #category : #layout }
MiNullQueryPresenter >> newLayout [

	^ SpBoxLayout newTopToBottom
		vAlignCenter;
		add: (self newLabel label: 'Please select a query');
		yourself
]
