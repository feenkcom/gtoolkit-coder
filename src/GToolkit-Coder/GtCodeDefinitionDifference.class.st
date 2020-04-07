Class {
	#name : #GtCodeDefinitionDifference,
	#superclass : #Object,
	#category : #'GToolkit-Coder-Behavior - Model'
}

{ #category : #enumerating }
GtCodeDefinitionDifference class >> difference: aCollectionOfDefinitions with: anOtherCollectionOfDefinitions addedDo: anAddedBlock removedDo: aRemovedBlock [
	"I do not try to find renamed differences and only rely on #name.
	Basically, renames are remove + add"
	| myNameMap otherNameMap addedDefs removedDefs |
	
	myNameMap := (aCollectionOfDefinitions collect: [ :each | each name -> each ]) asOrderedDictionary.
	otherNameMap := (anOtherCollectionOfDefinitions collect: [ :each | each name -> each ]) asOrderedDictionary.
	
	addedDefs := OrderedCollection new.
	removedDefs := OrderedCollection new.
	
	Array streamContents: [ :aStream | anOtherCollectionOfDefinitions do: [ :otherDef |
		myNameMap
			at: otherDef name
			ifAbsent: [ removedDefs add: otherDef ] ] ].

	aCollectionOfDefinitions do: [ :eachMyDef |
		otherNameMap
			at: eachMyDef name
			ifAbsent: [ addedDefs add: eachMyDef ] ].
		
	addedDefs do: anAddedBlock.
	removedDefs do: aRemovedBlock
]

{ #category : #enumerating }
GtCodeDefinitionDifference class >> difference: aCollectionOfDefinitions with: anOtherCollectionOfDefinitions addedDo: anAddedBlock renamedDo: aRenamedBlock removedDo: aRemovedBlock [
	| myOriginalNameMap myNameMap otherNameMap addedDefs removedDefs renamedDefs |
	
	myOriginalNameMap := (aCollectionOfDefinitions
		select: [ :each | each originalName isNotNil ]
		thenCollect: [ :each | each originalName -> each ]) asOrderedDictionary.
		
	myNameMap := (aCollectionOfDefinitions collect: [ :each | each name -> each ]) asOrderedDictionary.
	otherNameMap := (anOtherCollectionOfDefinitions collect: [ :each | each name -> each ]) asOrderedDictionary.
	
	addedDefs := OrderedCollection new.
	renamedDefs := OrderedCollection new.
	removedDefs := OrderedCollection new.
	
	Array streamContents: [ :aStream | anOtherCollectionOfDefinitions do: [ :otherDef |
		myOriginalNameMap
			at: otherDef name
			ifPresent: [ :myPresentDef |
				(myPresentDef name = otherDef name)
					ifFalse: [
						myNameMap
							at: myPresentDef originalName
							ifPresent: [  ]
							ifAbsent: [ renamedDefs add: myPresentDef ]
						 ].
			]
			ifAbsent: [
				myNameMap
					at: otherDef name
					ifAbsent: [ removedDefs add: otherDef ] ] ] ].
		
	aCollectionOfDefinitions do: [ :eachMyDef |
		otherNameMap
			at: eachMyDef name
			ifAbsent: [
				(renamedDefs includes: eachMyDef)
					ifFalse: [ addedDefs add: eachMyDef ] ] ].
		
	addedDefs do: anAddedBlock.
	renamedDefs do: aRenamedBlock.
	removedDefs do: aRemovedBlock
]

{ #category : #converting }
GtCodeDefinitionDifference >> asClassRefactorings: aClass [
	^ self asClassRefactorings: aClass in: RBNamespace new
]

{ #category : #converting }
GtCodeDefinitionDifference >> asClassRefactorings: aClass in: anRBModel [
	^ #()
]

{ #category : #testing }
GtCodeDefinitionDifference >> hasDifference [
	<return: #Boolean>
	
	^ true
]
