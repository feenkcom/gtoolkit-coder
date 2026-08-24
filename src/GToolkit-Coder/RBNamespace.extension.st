Extension { #name : #RBNamespace }

{ #category : #'*GToolkit-Coder' }
RBNamespace >> category: aString for: aClass [
	<gtPharoPatch: #Pharo>
	
	^ changes addChange: (RBClassCategoryChange category: aString for: aClass)
]

{ #category : #'*GToolkit-Coder' }
RBNamespace >> changedClasses [
	^ changedClasses
]

{ #category : #'*GToolkit-Coder' }
RBNamespace >> classObjectFor: anObject [
	<gtPharoPatch: #Pharo>
	
	(anObject isBehavior or: [anObject isTrait])
		ifTrue: [ ^ self classFor: anObject ].
	anObject isSymbol
		ifTrue: [ ^ self classNamed: anObject ].
	^ anObject
]

{ #category : #'*GToolkit-Coder' }
RBNamespace >> createNewClassFor: aBehavior [
	<gtPharoPatch: #Pharo>
	| nonMeta meta className rbType rbMetaType |
	className := aBehavior instanceSide name.
	(aBehavior isTrait and: [ aBehavior ~~ TraitedClass ])
		ifTrue: [ rbType := self rbTraitClass.
			rbMetaType := self rbTraitedMetaclassClass ]
		ifFalse: [ rbType := self rbClassClass.
			rbMetaType := self rbMetaclassClass ].
	nonMeta := rbType existingNamed: className model: self.
	meta := rbMetaType existingNamed: className model: self.
	nonMeta packageName: aBehavior package name.
	aBehavior packageTag isRoot
		ifFalse: [ nonMeta tagName: aBehavior packageTag name ].
	^ changedClasses at: className put: (Array with: nonMeta with: meta)
]

{ #category : #'*GToolkit-Coder' }
RBNamespace >> newClasses [
	^ newClasses
]

{ #category : #'*GToolkit-Coder' }
RBNamespace >> removePool: aString from: aRBClass [ 
	^changes removePool: aString from: aRBClass
]
