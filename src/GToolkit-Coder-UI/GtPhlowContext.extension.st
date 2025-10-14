Extension { #name : #GtPhlowContext }

{ #category : #'*GToolkit-Coder-UI' }
GtPhlowContext >> coderSelectedClass: aClass [
	^ self optionAt: #coderSelectedClass put: aClass
]

{ #category : #'*GToolkit-Coder-UI' }
GtPhlowContext >> coderSelectedClassIfPresent: aPresentBlock ifAbsent: anAbsentBlock [
	^ self
		optionAt: #coderSelectedClass
		ifPresent: aPresentBlock
		ifAbsent: anAbsentBlock
]

{ #category : #'*GToolkit-Coder-UI' }
GtPhlowContext >> coderSelectedClasses [
	^ self optionAt: #coderSelectedClasses ifAbsent: [ #() ]
]

{ #category : #'*GToolkit-Coder-UI' }
GtPhlowContext >> coderSelectedClasses: aCollectionOfClasses [
	^ self optionAt: #coderSelectedClasses put: aCollectionOfClasses
]
