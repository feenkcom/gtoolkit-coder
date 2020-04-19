Trait {
	#name : #TGtCoderNavigationClassesHelper,
	#category : #'GToolkit-Coder-Navigation - UI'
}

{ #category : #'private - ui' }
TGtCoderNavigationClassesHelper >> buildClassLabel: aClass [
	| aLabel |
	aLabel := BrLabel new
		look: (BrGlamorousLabelLook new fontSize: 12);
		text: aClass name.
		
	(self isAbstractClass: aClass)
		ifTrue: [ aLabel look italic ].
		
	^ aLabel
]

{ #category : #'private - testing' }
TGtCoderNavigationClassesHelper >> isAbstractClass: aClass [
	^ aClass isAbstract or: [ aClass hasAbstractMethods ]
]
