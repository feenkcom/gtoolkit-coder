Class {
	#name : #GtFilterVirtualWaitingModel,
	#superclass : #GtFilterModel,
	#traits : 'TGtUniqueInstance',
	#classTraits : 'TGtUniqueInstance classTrait',
	#category : 'GToolkit-Coder-UI-Filters - Models'
}

{ #category : #testing }
GtFilterVirtualWaitingModel >> isVirtualFilterModel [
	^ true
]

{ #category : #accessing }
GtFilterVirtualWaitingModel >> name [
	^ 'rendering...'
]
