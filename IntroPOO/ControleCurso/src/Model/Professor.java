package Model;

public class Professor extends Pessoa{
    //atributo
    private double salario;
    //construtor

    public Professor(String nome, String cpf, double salario) {
        super(nome, cpf);
        this.salario = salario;
    }
    //getters and setters

    public double getSalario() {
        return salario;
    }

    public void setSalario(double salario) {
        this.salario = salario;
    }

    @Override //polimorfismo
    public void exibirInformacoes() {
        // TODO Auto-generated method stub
        super.exibirInformacoes();
        System.out.println("Salário: "+salario);
    }
    

}
