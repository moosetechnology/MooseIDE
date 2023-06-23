"
I am a handler for queries coming from the MooseIDE Queries Browser, meant to be used by a rule in the Critic Browser.
"
Class {
	#name : #MiCriticBrowserFQQuery,
	#superclass : #MiCriticBrowserAbstractQuery,
	#category : #'MooseIDE-CriticBrowser-Queries'
}

{ #category : #running }
MiCriticBrowserFQQuery >> runOn: aGroupOfEntities [
self halt.
]
