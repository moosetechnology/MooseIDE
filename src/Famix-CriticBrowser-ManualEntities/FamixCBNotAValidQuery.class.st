"
I am NotAValidQuery, an error raised when a Rule is instantiated with a query not inheriting from the class MiCriticBrowserAbstractQuery.
"
Class {
	#name : 'FamixCBNotAValidQuery',
	#superclass : 'Error',
	#category : 'Famix-CriticBrowser-ManualEntities-QueryHandler',
	#package : 'Famix-CriticBrowser-ManualEntities',
	#tag : 'QueryHandler'
}

{ #category : 'accessing' }
FamixCBNotAValidQuery >> messageText [

	^ 'A rule must have a query inheriting from MiCriticBrowserAbstractQuery'
]
