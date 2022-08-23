"
I am NotAValidQuery, an error raised when a Rule is instantiated with a query not inheriting from the class MiCriticBrowserAbstractQuery.
"
Class {
	#name : #NotAValidQuery,
	#superclass : #Error,
	#category : #'MooseIDE-CriticBrowser-Queries'
}

{ #category : #accessing }
NotAValidQuery >> messageText [
	^ 'A rule must have a query inheriting from MiCriticBrowserAbstractQuery'
]
