Class {
	#name : #MiCBScriptQueryHandler,
	#superclass : #MiCBQueryHandler,
	#category : #'MooseIDE-CriticBrowser-Queries'
}

{ #category : #'instance creation' }
MiCBScriptQueryHandler class >> on: aString [

	^ self new
		  innerQuery: (FQSelectScriptQuery script: aString asValuable);
		  yourself
]

{ #category : #converting }
MiCBScriptQueryHandler >> asRuleEditorString [

	^ innerQuery script asString
]
