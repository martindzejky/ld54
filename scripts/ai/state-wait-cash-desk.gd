extends AIState
class_name AIStateWaitCashDesk


var cashDeskLeft: ItemContainer
var cashDeskRight: ItemContainer
var myProducts: Array[Node] = []


func enter():
    cashDeskLeft = get_tree().get_first_node_in_group('cash-desk-left')
    cashDeskRight = get_tree().get_first_node_in_group('cash-desk-right')
    
    assert(cashDeskLeft, 'Missing cash desk left side')
    assert(cashDeskRight, 'Missing cash desk right side')
    
    var products := get_tree().get_nodes_in_group('product')
    myProducts = products.filter(func (product): return product.customer == customer)
    
    # safety check
    if myProducts.size() == 0:
        print('Customer has no products to pay for at the cash desk, leaving')
        call_deferred('emit_signal', 'transition', 'leave')
        return


func update(_delta):
    
    # wait until all items are scanned and on the right side of the cash desk
    
    if myProducts.any(isNotScannedInRightSide):
        return
    
    print('All products are scanned and on the right side of cash desk')
    emit_signal('transition', 'cash-desk-pay')


func isNotScannedInRightSide(product: Node) -> bool:
    
    if not product.is_inside_tree(): return true
    if not product.isScanned: return true
    
    var parent := product.get_parent()
    if not parent: return true
    
    var container := parent.get_parent()
    if not container: return true
    if not container.is_in_group('cash-desk-right'): return true
    
    return false
