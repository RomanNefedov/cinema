function getHM(mins){
    var hours = Math.trunc(mins/60);
    var minutes = mins % 60;
    return (hours +" час. "+ minutes + " мин.");
}
export default getHM