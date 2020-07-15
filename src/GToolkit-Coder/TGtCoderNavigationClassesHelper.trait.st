Trait {
	#name : #TGtCoderNavigationClassesHelper,
	#category : #'GToolkit-Coder-Navigation - UI'
}

{ #category : #'private - ui' }
TGtCoderNavigationClassesHelper >> buildClassLabel: aClass [
	| aLook |
	aLook := (BrGlamorousLabelLook new fontSize: 12).

	(self isAbstractClass: aClass)
		ifTrue: [ aLook italic ].
	
	^ BrLabel new
		look: aLook;
		text: aClass name
]

{ #category : #'private - testing' }
TGtCoderNavigationClassesHelper >> isAbstractClass: aClass [
	^ aClass isAbstract or: [ aClass hasAbstractMethods ]
]
