Extension { #name : #ClassDescription }

{ #category : #'*GToolkit-VariableBindings' }
ClassDescription >> gtSlotNamed: aName ifFound: foundBlock ifNone: exceptionBlock [
	"By default, searches through all the slots in the object, however proxies may want to override this to display a different set (e.g. none)"
	^self classLayout resolveSlot: aName asSymbol ifFound: foundBlock ifNone: exceptionBlock
]

{ #category : #'*GToolkit-VariableBindings' }
ClassDescription >> gtSlotNames [
	"Answer the slot names to be bound by GtPharoSourceCoderViewModel.
	By default, this is all the slots in the object, however proxies may want to override this to display a different set (e.g. none)."

	^ self slotNames
]
