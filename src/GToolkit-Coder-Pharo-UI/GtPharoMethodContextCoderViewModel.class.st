Class {
	#name : #GtPharoMethodContextCoderViewModel,
	#superclass : #GtPharoMethodCoderViewModel,
	#category : #'GToolkit-Coder-Pharo-UI-! View Models'
}

{ #category : #initialization }
GtPharoMethodContextCoderViewModel >> initialize [
	super initialize.
	
	expanded := false
]

{ #category : #notifications }
GtPharoMethodContextCoderViewModel >> notifyContextPCRangeChangedTo: anInterval [
	self announcerUIModel
		announce: (GtMethodCoderContextPCRangeChanged new
			pcRange: anInterval)
]

{ #category : #accessing }
GtPharoMethodContextCoderViewModel >> programCounterRange [
	^ self coder 
		ifNotNil: [ :aCoder | aCoder programCounterRange ]
]

{ #category : #updating }
GtPharoMethodContextCoderViewModel >> updateProgramCounterRange [
	self notifyContextPCRangeChangedTo: self programCounterRange
]
