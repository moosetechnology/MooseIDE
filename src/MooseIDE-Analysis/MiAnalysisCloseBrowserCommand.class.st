Class {
	#name : #MiAnalysisCloseBrowserCommand,
	#superclass : #MiCommand,
	#category : #'MooseIDE-Analysis'
}

{ #category : #default }
MiAnalysisCloseBrowserCommand class >> defaultDescription [

	^ 'Close browser'
]

{ #category : #default }
MiAnalysisCloseBrowserCommand class >> defaultIconName [

	^ #smallDelete
]

{ #category : #default }
MiAnalysisCloseBrowserCommand class >> defaultName [

	^ 'Close browser'
]

{ #category : #executing }
MiAnalysisCloseBrowserCommand >> execute [

	self context closeBrowser
]
