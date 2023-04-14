Class {
	#name : #MiCBDeleteRuleCommand,
	#superclass : #MiAbstractCriticBrowserCommand,
	#category : #'MooseIDE-CriticBrowser-Commands'
}

{ #category : #'accessing - defaults' }
MiCBDeleteRuleCommand class >> defaultIconName [

	^ #smallDelete
]

{ #category : #'accessing - defaults' }
MiCBDeleteRuleCommand class >> defaultName [

	^ 'Delete rule'
]

{ #category : #accessing }
MiCBDeleteRuleCommand class >> priority [

	^ 2
]

{ #category : #execution }
MiCBDeleteRuleCommand >> canBeExecuted [

	^ self context rules selectedItem class ~= FamixCBRootContext
]

{ #category : #execution }
MiCBDeleteRuleCommand >> execute [

	self context
		deleteSelectedRule;
		updateRulesList
]
