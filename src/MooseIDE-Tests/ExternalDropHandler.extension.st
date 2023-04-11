Extension { #name : #ExternalDropHandler }

{ #category : #'*MooseIDE-Tests' }
ExternalDropHandler >> handler [
	"Helps in testing drop file events in MooseIDE-Tests-Application
	Added to strenghten MiApplicationTest>>#testJSONRegisteredHandler and MiApplicationTest>>#testMSERegisteredHandler"
	^action receiver
]
