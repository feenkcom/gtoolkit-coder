Trait {
	#name : #TGtCoderNavigationClassesHelper,
	#category : #'GToolkit-Coder-UI-Navigation'
}

{ #category : #'private - ui' }
TGtCoderNavigationClassesHelper >> buildClassLabel: aClass [
	| aLook aText |
	aLook := (BrGlamorousLabelAptitude new fontSize: 12).
	aText := aClass name.

	(self isAbstractClass: aClass)
		ifTrue: [ aLook italic ].
	
	(self isDeprecatedClass: aClass)
		ifTrue: [ 
			aText := aText, ' (deprecated)'.
			Transcript show: aText; cr.
			aLook bold ].
	
	^ BrLabel new
		aptitude: aLook;
		text: aText.
]

{ #category : #'private - testing' }
TGtCoderNavigationClassesHelper >> isAbstractClass: aClass [
	^ aClass isAbstract or: [ aClass hasAbstractMethods ]
]

{ #category : #'private - testing' }
TGtCoderNavigationClassesHelper >> isDeprecatedClass: aClass [
	^ aClass isDeprecated
]
