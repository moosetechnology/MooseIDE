Class {
	#name : #MiDoubleClickSettingPresenter,
	#superclass : #MiAbstractRadioButtonSettingPresenter,
	#category : #'MooseIDE-Dependency-ArchitecturalMap'
}

{ #category : #accessing }
MiDoubleClickSettingPresenter class >> help [

	^ 'What happens when double-clicking on an entity? '
]

{ #category : #accessing }
MiDoubleClickSettingPresenter class >> label [

	^ 'Double click action'
]

{ #category : #'event handling' }
MiDoubleClickSettingPresenter >> activate: aCommand [

	configuration doubleClickAction: aCommand
]

{ #category : #adding }
MiDoubleClickSettingPresenter >> addButton: aButton [

	self layout
		add: aButton
		width: (aButton label size roundUpTo: 10) * 6

	"No better idea to 
		- avoid radioButtons to wander off to the other side of the screen 
		- while having similar sizes when similar label length.
		
	6 is arbitrary"
]

{ #category : #building }
MiDoubleClickSettingPresenter >> helpForItem: aCommand [

	^ aCommand description
]

{ #category : #testing }
MiDoubleClickSettingPresenter >> isCurrentValue: aCommand [

	^ aCommand class = configuration doubleClickAction class
]

{ #category : #accessing }
MiDoubleClickSettingPresenter >> items [

	^ configuration availableDoubleClickActions
]

{ #category : #building }
MiDoubleClickSettingPresenter >> labelForItem: aCommand [

	^ aCommand name
]
