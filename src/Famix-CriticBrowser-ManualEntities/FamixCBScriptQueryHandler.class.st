Class {
	#name : #FamixCBScriptQueryHandler,
	#superclass : #FamixCBQueryHandler,
	#category : #'Famix-CriticBrowser-ManualEntities-QueryHandler'
}

{ #category : #'instance creation' }
FamixCBScriptQueryHandler class >> on: aString [

	^ self new
		  innerQuery: (FQSelectScriptQuery script: aString asValuable);
		  yourself
]

{ #category : #converting }
FamixCBScriptQueryHandler >> asRuleEditorString [

	^ innerQuery script asString
]
