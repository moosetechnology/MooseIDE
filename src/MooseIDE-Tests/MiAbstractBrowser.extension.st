Extension { #name : #MiAbstractBrowser }

{ #category : #'*MooseIDE-Tests' }
MiAbstractBrowser >> busButton [
	^ busButton
]

{ #category : #'*MooseIDE-Tests' }
MiAbstractBrowser >> follow [
	buttonFollow state: true
]

{ #category : #'*MooseIDE-Tests' }
MiAbstractBrowser >> freeze [
	buttonFreeze state: true
]

{ #category : #'*MooseIDE-Tests' }
MiAbstractBrowser >> highlight [
	buttonHighlight state: true
]

{ #category : #'*MooseIDE-Tests' }
MiAbstractBrowser class >> openForTests [

	^ (self
		   newApplication: MiTestApplication current
		   model: self newModel)
		  openWithSpec;
		  followBus: MiTestApplication current defaultBus;
		  yourself
]
